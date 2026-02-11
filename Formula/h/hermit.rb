class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://ghfast.top/https://github.com/cashapp/hermit/archive/refs/tags/v0.49.2.tar.gz"
  sha256 "ed72405d4f0e1a5942ee067f105a3f793035723b7963d5a8810bc4c1915d7cb4"
  license "Apache-2.0"
  head "https://github.com/cashapp/hermit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "810ead5cb5287b74ea344ca962e6fe20cc615e56755068eb608e2ef6b6202c89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2069f5ab3989a163bebac220cd77c4e96949e5cedcba9bb4573192283ac49bcc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3706f3ead6ebfb3b5ae4757811aef1278e0f0a1c2b233167a32b86fd093c2cae"
    sha256 cellar: :any_skip_relocation, sonoma:        "32a041991dbd5071caa967425e1ba0c7922979cc5c475aef56041d1a7c3a7783"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f7c1428c57d2101f2adb4d58cfaa0f9c6ac987287cb511c194bc157fcd0cfe5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23cf79ae0f4ea151849493a313ba8df515ab84d4d2983a615a412f4a5d1d851f"
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