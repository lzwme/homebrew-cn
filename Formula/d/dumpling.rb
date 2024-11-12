class Dumpling < Formula
  desc "Creating SQL dump from a MySQL-compatible database"
  homepage "https:github.compingcaptidb"
  url "https:github.compingcaptidbarchiverefstagsv8.4.0.tar.gz"
  sha256 "857ede56b8cf49c9db39d26c4a0ddd26093b8eaaa69c81be110a3b7f75a792dd"
  license "Apache-2.0"
  head "https:github.compingcaptidb.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80fc020d3242a44f224f4f6e246c73feaaf9926d531efd66c5af7e1be2d5d55e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5807bd3f495aac19de0516d2dfcf800a7744e72e7acf3cc5bf7c2af98490c2ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fdd587b8b054ecab18a7e63aa087e6bea06cd1d9e79179fd5bf845561735ac2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "600f7351450b15c79b521a9427fea036ea95f29d6e98e94c533bc9f5e2745b7c"
    sha256 cellar: :any_skip_relocation, ventura:       "ffc4a62e6287a6f08849b70b92da9bbabf6bd62c917f820a47ee4ed7bcc0dc1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8c32c2be6354e6bad1b1879d85a90a656206a4aec4fc783c7a539b82406952c"
  end

  depends_on "go" => :build

  def install
    project = "github.compingcaptidbdumpling"
    ldflags = %W[
      -s -w
      -X #{project}cli.ReleaseVersion=#{version}
      -X #{project}cli.BuildTimestamp=#{time.iso8601}
      -X #{project}cli.GitHash=brew
      -X #{project}cli.GitBranch=#{version}
      -X #{project}cli.GoVersion=go#{Formula["go"].version}
    ]

    system "go", "build", *std_go_args(ldflags:), ".dumplingcmddumpling"
  end

  test do
    output = shell_output("#{bin}dumpling --database db 2>&1", 1)
    assert_match "create dumper failed", output

    assert_match "Release version: #{version}", shell_output("#{bin}dumpling --version 2>&1")
  end
end