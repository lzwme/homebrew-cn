class Dstask < Formula
  desc "Git-powered personal task tracker"
  homepage "https://github.com/naggie/dstask"
  url "https://ghfast.top/https://github.com/naggie/dstask/archive/refs/tags/0.28.tar.gz"
  sha256 "6e0ede0b2b1cf392c04a06fede4935436abb6b488496045da1bd2671c65b24a7"
  license "MIT"
  head "https://github.com/naggie/dstask.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89954cb580c9471991eec2c889769b3366d307b5c7a6ad5c71fefaa073632f69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89954cb580c9471991eec2c889769b3366d307b5c7a6ad5c71fefaa073632f69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89954cb580c9471991eec2c889769b3366d307b5c7a6ad5c71fefaa073632f69"
    sha256 cellar: :any_skip_relocation, sonoma:        "a9a7eb7e0c5a7b9fa7180a841252a687513fbe9669e17e1356d2ab7fbb8c2bac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b17d1f243569771051b0178b27ffe50bde9d85e519ab301afe4a573d9060550d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fecd429a3bb86e32edbcf2eee4dc3fb1f0918016a2cef9b02289a7e97285b5b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:), "./cmd/dstask/main.go"
    system "go", "build", *std_go_args(ldflags:, output: bin/"dstask-import"), "./cmd/dstask-import/main.go"

    bash_completion.install "completions/bash.sh" => "dstask"
    fish_completion.install "completions/completions.fish" => "dstask.fish"
    zsh_completion.install "completions/zsh.sh" => "_dstask"
  end

  test do
    mkdir ".dstask" do
      system "git", "init"
      system "git", "config", "user.name", "BrewTestBot"
      system "git", "config", "user.email", "BrewTestBot@test.com"
    end

    system bin/"dstask", "add", "Brew the brew"
    system bin/"dstask", "start", "1"
    assert_match "Brew the brew", shell_output("#{bin}/dstask show-active")
    system bin/"dstask", "done", "1"
  end
end