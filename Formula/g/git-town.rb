class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https:www.git-town.com"
  url "https:github.comgit-towngit-townarchiverefstagsv15.3.0.tar.gz"
  sha256 "2b2d6fedc6e464b8b980b2cfabd790a5a11b260ffaf973030eb152b68759bc47"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1bc6f25aebd75326e1eecfa5fb7775215e48c60771ea86bd70666312edfe2814"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1bc6f25aebd75326e1eecfa5fb7775215e48c60771ea86bd70666312edfe2814"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1bc6f25aebd75326e1eecfa5fb7775215e48c60771ea86bd70666312edfe2814"
    sha256 cellar: :any_skip_relocation, sonoma:         "b634618020225e420e57f79c9fd8a2db3fe1d17130f7b23558bcb7f6ed453f33"
    sha256 cellar: :any_skip_relocation, ventura:        "b634618020225e420e57f79c9fd8a2db3fe1d17130f7b23558bcb7f6ed453f33"
    sha256 cellar: :any_skip_relocation, monterey:       "b634618020225e420e57f79c9fd8a2db3fe1d17130f7b23558bcb7f6ed453f33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6534d9b7e5c938d0309f70dd50d1d2cc89a90ed747dde08d9c45e0e42029276c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgit-towngit-townv#{version.major}srccmd.version=v#{version}
      -X github.comgit-towngit-townv#{version.major}srccmd.buildDate=#{time.strftime("%Y%m%d")}
    ]
    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin"git-town", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}git-town -V")

    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system bin"git-town", "config"
  end
end