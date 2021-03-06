(*
 * Copyright (c) 2015 Anil Madhavapeddy <anil@recoil.org>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 *)

(** Rules for generating Dockerfiles involving OPAM *)

(** RPM distribution specific rules involving OPAM and OCaml *)
module RPM : sig

  val install_base_packages : Dockerfile.t
  (** Install the base development packages *)

  val install_system_ocaml : Dockerfile.t
  (** Install the system OCaml packages via Yum *)

  val install_system_opam : [< `CentOS6 | `CentOS7 ] -> Dockerfile.t
  (** Install the system OPAM packages via Yum *)

  val add_opensuse_repo : [< `CentOS6 | `CentOS7 ] -> Dockerfile.t
  (** Add a Yum entry for the OpenSUSE Build Service OCaml repo *)

end

(** Apt distribution specific rules involving OPAM and OCaml *)
module Apt : sig

    val install_base_packages : Dockerfile.t
    (** Install the base packages required by OPAM, such as [unzip],
        [curl] and so on. *)

    val install_system_ocaml : Dockerfile.t
    (** Install the system OCaml packages via [apt-get] *)

    val install_system_opam : Dockerfile.t
    (** Install the system OPAM packages via [apt-get] *)

    val add_opensuse_repo :
      [< `Debian of [< `Stable | `Testing ]
       | `Ubuntu of [< `V14_04 | `V14_10 ] ] -> Dockerfile.t
    (** Add a [apt] repository entry for the OpenSUSE Build
        Service repository for OCaml *)
  end

val run_as_opam : ('a, unit, string, Dockerfile.t) format4 -> 'a
(** [run_as_opam fmt] runs the command specified by the [fmt]
    format string as the [opam] user. *)

val opamhome : string
(** The location of the [opam] user home directory *)

val opam_init :
  ?repo:string -> ?compiler_version:string -> unit -> Dockerfile.t
(** [opam_init ?repo ?compiler_version] initialises the OPAM
    repository.  The [repo] is [git://github.com/ocaml/opam-repository]
    by default.  If [compiler-version] is specified, an [opam switch]
    is executed to that version.  If unspecified, then the [system]
    switch is default. *)

val install_opam_from_source : ?prefix:string -> ?branch:string -> unit -> Dockerfile.t
(** Commands to install OPAM via a source code checkout from GitHub.
    The [branch] defaults to the [1.2] stable branch.
    The binaries are installed under [<prefix>/bin], defaulting to [/usr/local/bin]. *)

val install_ext_plugin : Dockerfile.t
(** Installs the external dependency plugin shell script. *)

val header: string -> string -> Dockerfile.t
(** [header image tag] initalises a fresh Dockerfile using the [image:tag]
    as its base. *)

val generate_dockerfiles : string -> (string * Dockerfile.t) list -> unit
(** [generate_dockerfiles output_dir (name * docker)] will
    output a list of Dockerfiles inside the [output_dir/name] subdirectory,
    with each directory containing the Dockerfile specified by [docker]. *)
