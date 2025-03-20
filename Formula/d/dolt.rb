class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.50.7.tar.gz"
  sha256 "21232b8f2deac2676a3b219ddc34911041b5112dc5b99cfd229804284dc0b9bb"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b3257d0e8c36ab0c792473a075b19a00677287ed1d3fb8b4343383ee3500e00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d563b2d61bb05ef0eea6fd9404dc25c8f4024abcfcfe3c7d2a00cd79a9c9c352"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "21c77922c1b365d96628849f91d8a33f5c01fed2cf1095c3baf022163e0eb873"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a2a6bf821fcb5f19282cbda59b3a3bfd32a88ecef7c8330a08f5d01bada3fe8"
    sha256 cellar: :any_skip_relocation, ventura:       "f2540e8e4e5959df9457c7b89c73e2a596f1a4aa6d840af788cd9478a4d3f08b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14cb3ab9c9426bae840c0fda8d6bad1d2fa09a72a590edebff6fc275c248d4c5"
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