class Pitchfork < Formula
  desc "CLI for managing daemons with a focus on developer experience"
  homepage "https://pitchfork.jdx.dev"
  url "https://ghfast.top/https://github.com/jdx/pitchfork/archive/refs/tags/v2.20.0.tar.gz"
  sha256 "f6a36097a7f288d428988fdd3664154e1ad847b7a4fdb60065e44587f1b2179e"
  license "MIT"
  head "https://github.com/jdx/pitchfork.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b56dccb8e7f6de0ced583f9b792521f2d1092b9d27ff693b7ff555bf05e1166"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4993d62f28c52c7e74c4d56e003e8c1a1a9e011cc55f52595f27a345cd85d851"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f162ad0fa676be6b9d0ca34aa079f055ab7f90b4171b7c9e7b7deeab697a8a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "2546005ee5495946dda66a83b858f3b980ed85de0f59a861636a91da8f7c1373"
    sha256 cellar: :any,                 arm64_linux:   "23db02694c30a11dddabaa95dbe719b3936e0b9ca9f1eac203ad31ab6aefcf19"
    sha256 cellar: :any,                 x86_64_linux:  "7e2e450f11ce36ae272db528b2e901c0a9e33ac38c606b51516e1e84fe6a10d0"
  end

  depends_on "rust" => :build
  depends_on "usage"

  def install
    (buildpath/"ui/dist").mkpath

    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"pitchfork", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pitchfork --version")

    system bin/"pitchfork", "daemons", "add", "brewtest", "--run", "echo brewed", "--ready-output", "brewed"
    config = (testpath/"pitchfork.toml").read
    assert_match 'run = "echo brewed"', config
    assert_match 'ready_output = "brewed"', config
  end
end