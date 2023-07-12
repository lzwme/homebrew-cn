class Wazero < Formula
  desc "Zero dependency WebAssembly runtime"
  homepage "https://wazero.io"
  url "https://ghproxy.com/https://github.com/tetratelabs/wazero/archive/v1.3.0.tar.gz"
  sha256 "11ba1f827dcd3ae0572bb471bd52347224eadec03c9c3dd4452e401332ea3cb0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7725fcdad1d67ed18ca46cc537d05ddca05c2adb5ab966aff4749bc164b104b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7725fcdad1d67ed18ca46cc537d05ddca05c2adb5ab966aff4749bc164b104b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7725fcdad1d67ed18ca46cc537d05ddca05c2adb5ab966aff4749bc164b104b1"
    sha256 cellar: :any_skip_relocation, ventura:        "052b5fe05aa6eabdb1a9824e32350b418c87eb0ec566539fd38e0fa9d7aa7e6f"
    sha256 cellar: :any_skip_relocation, monterey:       "052b5fe05aa6eabdb1a9824e32350b418c87eb0ec566539fd38e0fa9d7aa7e6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "052b5fe05aa6eabdb1a9824e32350b418c87eb0ec566539fd38e0fa9d7aa7e6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41aefc7c3fddba1f9c5add1caaeef265bc3cec921b2e4f052eb8b1609617e352"
  end

  depends_on "go" => :build
  depends_on "wabt" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/tetratelabs/wazero/internal/version.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/wazero"
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