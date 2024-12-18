class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.45.0.tar.gz"
  sha256 "e8db9e5dc0d9db055cf28db0bc19aadd3db2eec7d12bcea66d15e59350848a6d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43f2e1f689b60acadb9dda94198fd4b2a61db21b952178e1881ad08fae09b22d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17767fa5f62a0d2ba20bdd5652168b968aebd3c7c24addbf104dc6d12a21bcc5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2bd91b3db5616a491b911aceded083697202046d362b5a89bf25c75f40e61ec6"
    sha256 cellar: :any_skip_relocation, sonoma:        "97a7ccdf2a04e74750733242f24ee2ee4aaadf9d70bb0ccc63ca3dc224fa8528"
    sha256 cellar: :any_skip_relocation, ventura:       "26f3b8380ee05052b9716ccba7bfed1ecba725d0737a1f6ee35c0e06e8a66eea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a30e07c8a78fdea06aaf29547a93733c15d65a2fd42ac7d9d8f419e7ab77006a"
  end

  depends_on "go" => :build

  def install
    chdir "go" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmddolt"
    end
  end

  test do
    ENV["DOLT_ROOT_PATH"] = testpath

    mkdir "state-populations" do
      system bin"dolt", "init", "--name", "test", "--email", "test"
      system bin"dolt", "sql", "-q", "create table state_populations ( state varchar(14), primary key (state) )"
      assert_match "state_populations", shell_output("#{bin}dolt sql -q 'show tables'")
    end
  end
end