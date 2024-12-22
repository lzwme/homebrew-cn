class CargoLlvmCov < Formula
  desc "Cargo subcommand to easily use LLVM source-based code coverage"
  homepage "https:github.comtaiki-ecargo-llvm-cov"
  # cannot use github tarball due to https:github.comtaiki-ecargo-llvm-covpull152#issuecomment-1107055622
  url "https:static.crates.iocratescargo-llvm-covcargo-llvm-cov-0.6.15.crate"
  sha256 "ed705118c3dde996f7e74550cf8d7c76ca9f5573f231cd0a201833c2648ab1a9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comtaiki-ecargo-llvm-cov.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f32e757e53726b6ed2c90e2b1d362b14ac5667e4033750caea0818ef8816b68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "024a508a934027bade593838fbace10cb884807d9d83fa7b426ef0cede6b5cb8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f7f09ca0772d833f7ee2b331c9d4bf3d9f1fb717c6a2982e55c6bed81b8f87bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "69396e8400c86bd264de37f523922c4f65875942abac9d85b257d9e460ffb06d"
    sha256 cellar: :any_skip_relocation, ventura:       "099826aa256531bb12798bd4b638fed863312ca683d5282df4cff1b207d8db52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee6dbbcf157e1c40e7082460cf3a72a6fa1bdc3d103c2e0a323da9a52d140776"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https:github.comHomebrewhomebrew-corepull134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

    system "cargo", "new", "hello_world", "--lib"
    cd "hello_world" do
      system "cargo", "llvm-cov", "--html"
    end
    assert_predicate testpath"hello_worldtargetllvm-covhtmlindex.html", :exist?
  end
end