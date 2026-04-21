class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://ghfast.top/https://github.com/cashapp/hermit/archive/refs/tags/v0.52.0.tar.gz"
  sha256 "58c742b2bb2bbdb2ee4c2d74cb31dbdb39a17c1ab2f3f43db3711551448ae1e1"
  license "Apache-2.0"
  head "https://github.com/cashapp/hermit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4dbfe7ea4e934bbd931b5f0abe6f2b13b92967ffc8a4c67e8018e5ae3ce5fe0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfcd4af7feebc34fb33a3e0694d8efe4053f777ae6f0da40671a7a1d18d3a6d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8441c56bd71753fbd74dee906f020cd11529e404e5a3297d9536743860b2a346"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b7a04914905625b33a5dd3ba5b5ef0c10a2c4da4a26683aa051fa86035f79cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65501734d99916151a1c097dad096cd886153d1b5c2df7bb4fc98a29f2c16860"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9d4399a80a798c60e2c00930fc6b275f0f4807794c78355da9eb9f4610fcc06"
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