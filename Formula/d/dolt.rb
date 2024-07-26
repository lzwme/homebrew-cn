class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.42.3.tar.gz"
  sha256 "eb6f99225c59308fa66c423885a46539dc5ea34b43db9f6b31b933cffc9f90e8"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "740d373ecb6be14f23d1bcf252c5a0e96132f14ee3043d4dafa2d5558c2f28c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a45a7738bba35c66d1bba9da7e97ba22cc6be0b90a4e938e9ad2be2c1a56d2e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "195f93adda4b54f5993e372cbbf6ae94ed97a54f4e9592943658ff0299d45ea4"
    sha256 cellar: :any_skip_relocation, sonoma:         "4c7c708747f56fc7536774d4ecc70e43b123dc11821e17bd4dceae3eb07767b2"
    sha256 cellar: :any_skip_relocation, ventura:        "a98c78a7387d0aeb73009d95607ba6640a994c9c47bf1eacc089845151dd2a2f"
    sha256 cellar: :any_skip_relocation, monterey:       "9b83feec22309d8382e99a147ff8d39232438f3b5aee828cbbbdc786352ed940"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d9ce0b9e02d1eba6bd75fdd695f49ec140de252ee8946d247e0c264e50472b4"
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