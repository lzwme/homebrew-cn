class Wazero < Formula
  desc "Zero dependency WebAssembly runtime"
  homepage "https://wazero.io"
  url "https://ghfast.top/https://github.com/tetratelabs/wazero/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "333b667c784e2c6ae0a25142508a0e9197de6196ca638ba821dde65bd9690de0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9527e4a73a05a2f706ccfcd248a66fc61fa2c5894914bca81e2c396a4f134c23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9527e4a73a05a2f706ccfcd248a66fc61fa2c5894914bca81e2c396a4f134c23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9527e4a73a05a2f706ccfcd248a66fc61fa2c5894914bca81e2c396a4f134c23"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd68b8019c37c306fc2225a08dd32a4e465587efb21f197c7e9f3c08ac285faf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91620f113f9a16cc6cbbdc4e11a390473f15ff13ca4d2b2e455f9e98c0481844"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "219428bb9aa382d5abd430bfbe35a764aa291326dd94c6318e11ac2b55fae7d9"
  end

  depends_on "go" => :build
  depends_on "wabt" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/tetratelabs/wazero/internal/version.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/wazero"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/wazero version").chomp

    (testpath/"mount.wat").write <<~EOS
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

    system "wat2wasm", testpath/"mount.wat", "-o", testpath/"mount.wasm"

    assert_equal "/homebrew",
      shell_output("#{bin}/wazero run -mount=/tmp:/homebrew #{testpath/"mount.wasm"}")
  end
end