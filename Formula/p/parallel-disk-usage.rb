class ParallelDiskUsage < Formula
  desc "Highly parallelized, blazing fast directory tree analyzer"
  homepage "https:github.comKSXGitHubparallel-disk-usage"
  url "https:github.comKSXGitHubparallel-disk-usagearchiverefstags0.11.1.tar.gz"
  sha256 "77dc084baff20c5ef647693ab070300d2a873484f5f30ab1e4d7681eeb20fec7"
  license "Apache-2.0"
  head "https:github.comKSXGitHubparallel-disk-usage.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d6cc0c555c307817f9ba2fca5e393a4572b2fbfdfab74e7e546cd48da83686a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e7f0f48aa05cceae8f5b2dedeb1360cc3b6c141f707f8767ec8e0a0779d7d03"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e331e254a262c5bf50cf709dc46f840e512a43c4a77d2b227db1222b7e15c909"
    sha256 cellar: :any_skip_relocation, sonoma:        "95532eeaf6091a081d2a2b3c3f6ee72918bd6cef8d30de96d3bc1f034139028d"
    sha256 cellar: :any_skip_relocation, ventura:       "7606fe68c4e3d01b4726051612fca0546f4a77f4a6e805e0bb265ef7d5f820c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b514b30c76713b5f80a066bfcd83edcaa5e1749851f8705954b9b99fe60c0df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "781da38254e684ff248a0dbce10df9850b72f4fddd7964d20f1048379b2cb344"
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