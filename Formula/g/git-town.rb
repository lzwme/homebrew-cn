class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https:www.git-town.com"
  url "https:github.comgit-towngit-townarchiverefstagsv18.1.0.tar.gz"
  sha256 "29bc99bd31d5b469da6922fcee6ee0e4afd20f63c43f6d4f25d07577eba7b5d8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f1e72e2857e59b7ec99abd7840bdacb83a84eb3bf8fb65d74a792f394b5b83d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f1e72e2857e59b7ec99abd7840bdacb83a84eb3bf8fb65d74a792f394b5b83d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f1e72e2857e59b7ec99abd7840bdacb83a84eb3bf8fb65d74a792f394b5b83d"
    sha256 cellar: :any_skip_relocation, sonoma:        "22f5384f4f68e405913ed157dbdaa2be73479df03ca970a61f07205fe9da0d51"
    sha256 cellar: :any_skip_relocation, ventura:       "22f5384f4f68e405913ed157dbdaa2be73479df03ca970a61f07205fe9da0d51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25d5d905a2c7afb2b317c0109fc22ef334a7a84fd1965a1c1b6c9c4dd3dac32c"
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