class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/v1.8.8.tar.gz"
  sha256 "20ea7519d682ba2d2a24e8d8a9f964b46b38fa81a0393da4ca7c634229f71c8a"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f6194c8fc7b992bb7ef523cee58eefe272ac409adbbe89a88ef20855a4c1f0f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f6194c8fc7b992bb7ef523cee58eefe272ac409adbbe89a88ef20855a4c1f0f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f6194c8fc7b992bb7ef523cee58eefe272ac409adbbe89a88ef20855a4c1f0f"
    sha256 cellar: :any_skip_relocation, ventura:        "94f5c01dc1c9b7223f52b1b60c8e1aea5a1c43b277f35d1000eaae88a8371978"
    sha256 cellar: :any_skip_relocation, monterey:       "94f5c01dc1c9b7223f52b1b60c8e1aea5a1c43b277f35d1000eaae88a8371978"
    sha256 cellar: :any_skip_relocation, big_sur:        "94f5c01dc1c9b7223f52b1b60c8e1aea5a1c43b277f35d1000eaae88a8371978"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19ee49b79459ad6d7f6f2e0dea2279f904375d8448ce25a40929568afbf2a80c"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args, "./cmd/dolt"
    end
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin/"dolt", "init", "--name", "test", "--email", "test"
      system bin/"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}/dolt sql -q 'show tables'")
    end
  end
end