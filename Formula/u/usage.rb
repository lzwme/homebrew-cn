class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://ghfast.top/https://github.com/jdx/usage/archive/refs/tags/v6.6.0.tar.gz"
  sha256 "92c0b0653bcda66db04b0cdb35697d8dddccd987dc17d84113260a681fd88dce"
  license "MIT"
  compatibility_version 1
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05328115d3665520db78b95439302c75131182ac8160b53651eb10a7b25302c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ffe9f99d62b87ca0c8b223b3f44f07d21e6ee9cba4355a4e808e357606685dc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19da148d9ce149e409e507050f772c2cad76a36706d0c642cdb0c22fb36c2e22"
    sha256 cellar: :any,                 arm64_linux:   "079be020a20f69f36a8a5b7510a395489e8dee0ce3861d6c251531c2a94f8664"
    sha256 cellar: :any,                 x86_64_linux:  "b527224c469ac040c6813b0f1e1f3b3a902ea8e49ce3ff4de81b4c6b06ad6a64"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    man1.install "cli/assets/usage.1"
    generate_completions_from_executable(bin/"usage", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/usage --version").chomp
    assert_equal "--foo", shell_output("#{bin}/usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end