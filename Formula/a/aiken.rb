class Aiken < Formula
  desc "Modern smart contract platform for Cardano"
  homepage "https://aiken-lang.org/"
  url "https://ghfast.top/https://github.com/aiken-lang/aiken/archive/refs/tags/v1.1.20.tar.gz"
  sha256 "4b5cf92ab906f57d274df386341d3c63371ba3a5ef7cfe48532252de2d068653"
  license "Apache-2.0"
  head "https://github.com/aiken-lang/aiken.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "701cf5b6062bd81c168d9613b6d4e3574d02e76aaf195fd6b690a64cc6993216"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f4b47c67ffb94284ee0d209b0a6b82e67b660265e1a7c6165a7c09fbcf997b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c937accab146688a8e3afbd509a621bcd46de6e62ab88e3d07f674beac33f969"
    sha256 cellar: :any_skip_relocation, sonoma:        "80850de630aa987a033bffca1c5d6b874fc4cd2ed63da8b27a95731a625fe2d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "787fb69fb5c5e4a89c3e79d26d386e20c58e5b58e705511b404a83452b901269"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fa8b567216587062dc780b5dad25884ff3d503e42a9063e6dd707350a2db55d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/aiken")

    generate_completions_from_executable(bin/"aiken", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aiken --version")

    system bin/"aiken", "new", "brewtest/hello"
    assert_path_exists testpath/"hello/README.md"
    assert_match "brewtest/hello", (testpath/"hello/aiken.toml").read
  end
end