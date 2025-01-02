class Serie < Formula
  desc "Rich git commit graph in your terminal"
  homepage "https:github.comlusinganderserie"
  url "https:github.comlusinganderseriearchiverefstagsv0.4.1.tar.gz"
  sha256 "f806e5d818c6211bb1d194b4e751b5ab1dd4571a5857e910fdca29e77c2cf4e8"
  license "MIT"
  head "https:github.comlusinganderserie.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6456a66f53969dd3367af21b077fc2932764f732ba8f7743353e6a587309ac61"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dac857c650b3a380959fcbb6fea3fbf4ab6c304d85db9f221d2da1bac9b7f43d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6f4fd7d23914c404e00d161917663d471b0c9ba746bdd6311dc1b80231f45698"
    sha256 cellar: :any_skip_relocation, sonoma:        "c42af1688492dba546f3bf88b70df537d73da720f6aa6d948de274739285aac1"
    sha256 cellar: :any_skip_relocation, ventura:       "8af3a8c67e926bcb8243bfa3e50a2cdfd0878befc76808b1ad1cf72bb86e5020"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9f3ef62cad5700569f19914158dd5079583a3a942e1ec1eb5cc3175718071e0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}serie --version")

    # Fails in Linux CI with "failed to initialize terminal: ... message: \"No such device or address\" }"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "Initial commit"

    begin
      output_log = testpath"output.log"
      pid = spawn bin"serie", [:out, :err] => output_log.to_s
      sleep 1
      assert_match "Initial commit", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end