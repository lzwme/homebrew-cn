class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://ghfast.top/https://github.com/cashapp/hermit/archive/refs/tags/v0.50.0.tar.gz"
  sha256 "15b144d4b4358329660ed8a69adef39303d98b81ad94d0cecbf3433a7b55b0f9"
  license "Apache-2.0"
  head "https://github.com/cashapp/hermit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16e82e77cbe7d370ae84c906f3612160a5a80c87818038a0c01b5f4cc20acd0f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5fcea8ce8a8e2301a9ebc432ab54484fb7dbea79ac892b6cb37c4bef1d0ef99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8b5cf89573cc4779a50fee53d9a35338e1fa3eb25fa4c01af04d597ee49c6c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "0960776c7c2ef82fcc265a184a980c98075cf1dcb38e51bebd658f639ee3a07b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "227a9c6c0d48a41029f92ee8fe52fb1255a615ab4930150bd05770f041218831"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29c7e7a0cf8f74720c06187749d28a94685e91e36e3892aba725d79320486e85"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.channel=stable
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/hermit"
  end

  def caveats
    <<~EOS
      For shell integration hooks, add the following to your shell configuration:

      For bash, add the following command to your .bashrc:
        eval "$(test -x $(brew --prefix)/bin/hermit && $(brew --prefix)/bin/hermit shell-hooks --print --bash)"

      For zsh, add the following command to your .zshrc:
        eval "$(test -x $(brew --prefix)/bin/hermit && $(brew --prefix)/bin/hermit shell-hooks --print --zsh)"
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hermit version")
    system bin/"hermit", "init", "."
    assert_path_exists testpath/"bin/hermit.hcl"
  end
end