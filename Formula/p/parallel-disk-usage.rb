class ParallelDiskUsage < Formula
  desc "Highly parallelized, blazing fast directory tree analyzer"
  homepage "https:github.comKSXGitHubparallel-disk-usage"
  url "https:github.comKSXGitHubparallel-disk-usagearchiverefstags0.12.0.tar.gz"
  sha256 "f3093800ed425d550bfa8574a365a3a23ccc5b58733158e992462cf5fa98b822"
  license "Apache-2.0"
  head "https:github.comKSXGitHubparallel-disk-usage.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3ff2ce5c5625d4b8386669c0a9e8814e3db8ba553652d31d32ea6edfe6a6481"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3903c71af59b7e43008c68d2f090f4c12c5ba96c3018f959c12a3a0d0c8bb607"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4104b3671dc7332b48f2380fb7e828e3edd23c1333573ca31daf250c9e1440bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d5c02ec12ce22fbecba199f597997a9e6266de5fa01fb79b8bfb45bfc4a12cb"
    sha256 cellar: :any_skip_relocation, ventura:       "05e2ab18e7a7bda4dae465e2792e31ee9562a5051d626bfb67e9c0fe13690242"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34928a37a3a085e7869d63af4440e6d6684a923038021c4804d6d6abe02939e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97ee2d780c179ac75e46c144cbc87b57e67431d47e6d1544da196f60f0c89a1b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "cli,cli-completions", *std_cargo_args

    system bin"pdu-completions", "--name", "pdu", "--shell", "bash", "--output", "pdu.bash"
    system bin"pdu-completions", "--name", "pdu", "--shell", "fish", "--output", "pdu.fish"
    system bin"pdu-completions", "--name", "pdu", "--shell", "zsh", "--output", "_pdu"
    bash_completion.install "pdu.bash" => "pdu"
    fish_completion.install "pdu.fish"
    zsh_completion.install "_pdu"

    rm bin"pdu-completions"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}pdu --version")

    system bin"pdu"

    (testpath"test").write("test")
    system bin"pdu", testpath"test"
  end
end