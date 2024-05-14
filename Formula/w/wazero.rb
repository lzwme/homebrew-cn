class Wazero < Formula
  desc "Zero dependency WebAssembly runtime"
  homepage "https:wazero.io"
  url "https:github.comtetratelabswazeroarchiverefstagsv1.7.2.tar.gz"
  sha256 "6348e07bd3e73fef3126687c5d881ccbcaf24075769a97ed583a2cd6aee271fe"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "609817b5ae874200dc2b4de76594ab52f6e2044aa880607bd7b816ccad875103"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ce14492b2db93bb01adad38766043d2a9d3d86df93879f703d54c3845a0dd16"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92170a11215d620bc09f430423e11b121317ff78d19398ca58b3939c17ee9727"
    sha256 cellar: :any_skip_relocation, sonoma:         "367e7b4b058517851c749cbc844a902517c5d6e78f5f3545146175368abef9db"
    sha256 cellar: :any_skip_relocation, ventura:        "94f4cac28e6b54e2334f0927db531eb8a0c45fdaf935819a4b44426b5123d898"
    sha256 cellar: :any_skip_relocation, monterey:       "7018c7f6e46cbf27eb41185cde566fa85a8bc4433a015bae16e4796419bbcb22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acfacc0cf19478f498d1ea450cf96e5c510665648a9afea1eb9df932930d893f"
  end

  depends_on "go" => :build
  depends_on "wabt" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.comtetratelabswazerointernalversion.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdwazero"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}wazero version").chomp

    (testpath"mount.wat").write <<~EOS
      ;; print the preopen directory path (guest side of the mount).
      (module
        (import "wasi_snapshot_preview1" "fd_prestat_get"
          (func $wasi.fd_prestat_get (param i32 i32) (result i32)))

        (import "wasi_snapshot_preview1" "fd_prestat_dir_name"
          (func $wasi.fd_prestat_dir_name (param i32 i32 i32) (result i32)))

        (import "wasi_snapshot_preview1" "fd_write"
          (func $wasi.fd_write (param i32 i32 i32 i32) (result i32)))

        (memory (export "memory") 1 1)

        (func $main (export "_start")
          ;; First, we need to know the size of the prestat dir name.
          (call $wasi.fd_prestat_get
            (i32.const 3) ;; preopen FD
            (i32.const 0)) ;; where to write prestat
          (drop) ;; ignore the errno returned

          ;; Next, write the dir name to offset 8 (past the prestat).
          (call $wasi.fd_prestat_dir_name
            (i32.const 3) ;; preopen FD
            (i32.const 8) ;; where to write dir_name
            (i32.load (i32.const 4))) ;; length is the last part of the prestat
          (drop) ;; ignore the errno returned

          ;; Now, convert the prestat to an iovec [offset, len] writing offset=8.
          (i32.store (i32.const 0) (i32.const 8))

          ;; Finally, copy the dirname to stdout via its iovec [offset, len].
          (call $wasi.fd_write
            (i32.const 1) ;; stdout
            (i32.const 0) ;; where's the iovec
            (i32.const 1) ;; only one iovec
            (i32.const 0)) ;; overwrite the iovec with the ignored result.
          (drop) ;; ignore the errno returned
        )
      )
    EOS

    system "wat2wasm", testpath"mount.wat", "-o", testpath"mount.wasm"

    assert_equal "homebrew",
      shell_output("#{bin}wazero run -mount=tmp:homebrew #{testpath"mount.wasm"}")
  end
end