class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.43.0.tar.gz"
  sha256 "74c87c4357e2a4d2c468e77043d61ef3a72314939c48009989ec46469b68f047"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7957bb0005e742a1d1082dbe05350e504115823fc90abf22d4b291d8fe77fff0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97168c0c92ac58e3cc3e05b4f868e99132e01c3c5cce8a706bb4142125e93da4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b25a65e53056655be42d70447baa65f73c00c205d18ca8064cb96c7a47bd9fad"
    sha256 cellar: :any_skip_relocation, sonoma:        "e673d7c2c980d5fcb26fd53cb4fce81151db47bf9f87ad315f0806d0b3d52e59"
    sha256 cellar: :any_skip_relocation, ventura:       "781e6fa601c7aa7098cb113e924d9d312bd4f389d94686631a3ba059b6bda7d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e157b2be1eff301f1790f6ad3caf4510f15cfb2b37c82009db821b7e1d9684c"
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