class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.47.2.tar.gz"
  sha256 "cc1092d96de7f3c8e298b58e6cefe046176dbbb6c98918d42b23fe02b84e760a"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51e1aba14e8cb5884ecd5e1a4de5a017e4aa39b0f5616d67b737d0b4e0f01b13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4f17232a051bd8542d5579f50165bfe9bc6ccf23541bced62fd79eada050b06"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c469bc7023e4a7c598597bc376bc3c5c6f03c3f43d0a174d916cef6535647518"
    sha256 cellar: :any_skip_relocation, sonoma:        "3cc65aaa19b3b119ea8a161b0fa83984727c6a44dfceb249efe08f19a636def6"
    sha256 cellar: :any_skip_relocation, ventura:       "8e2839e30e9bcd40c3821fd4795ffc81bb5bc2579442a01b241668cf43d722da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc94197676372a31264bf0b0f96df2839e3089df54b2b52108455e6bee477d59"
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