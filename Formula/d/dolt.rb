class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.44.4.tar.gz"
  sha256 "072095258207036928e9908ecb071f71af71ca3e6760d1ea1cfd815b21188ecb"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68a19852b9c8c7da1fb0c532dd14a71d989a0e2642793cb4c156992bc6c7e3b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "651fad56ae923d218f6f20738c0a5297cc7d0c6604a8eef0c1084d4102700e40"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "68664764fdb720f1029ae4ce21517e39c32648c14d8211fc896a706bced47e59"
    sha256 cellar: :any_skip_relocation, sonoma:        "543906db7ccb6787018c71d3511e2a633156c55b130b2d355992617f607bc067"
    sha256 cellar: :any_skip_relocation, ventura:       "5c58db0b2dbacd89c01880574de9b147b6dc76d8b4b9f6b6dc1da6b6df2a688f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d878491058f7314ce6e5a7c787aa42b46743ff1d97284364f782a8a0cc58ccd2"
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