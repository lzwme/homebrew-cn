class Typst < Formula
  desc "Markup-based typesetting system"
  homepage "https://typst.app/"
  url "https://ghfast.top/https://github.com/typst/typst/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "83d132348a8c9481a8a483cdf823d5083ba456466410935f25240f6c26e23c38"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/typst/typst.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c461ba513d73ecab4a57d719154b033da73ba525e5cba5fded52d7dd55f19bdf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c2fa62ead5a50168ced0bce56bd745ff88384a0e2ad9672a6a8d1bae7a75d20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96c73fbcd4b585c8795bf7c798df99cf08307f36450d9abc77c64f8b677fe87d"
    sha256 cellar: :any_skip_relocation, sonoma:        "64fbad1787d63629ed3743d1c3ab5abca77c7092b4e381f7507943897359aa9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2f234a144da6c8b440ab5c683d0aae1c8ac45db40ec18bf1c7d2564dd4c6351"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd6f73e4d01457fa7bb3bcab67e719ccd5e326e5a82b20d1ab982e8e5469e67c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    ENV["TYPST_VERSION"] = version.to_s
    ENV["GEN_ARTIFACTS"] = "artifacts"
    system "cargo", "install", *std_cargo_args(path: "crates/typst-cli")

    man1.install buildpath.glob("crates/typst-cli/artifacts/*.1")
    generate_completions_from_executable(bin/"typst", "completions")
  end

  test do
    (testpath/"Hello.typ").write("Hello World!")
    system bin/"typst", "compile", "Hello.typ", "Hello.pdf"
    assert_path_exists testpath/"Hello.pdf"

    assert_match version.to_s, shell_output("#{bin}/typst --version")
  end
end