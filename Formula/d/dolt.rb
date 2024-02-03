class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.32.6.tar.gz"
  sha256 "aeb93aa873d337495f20cde229a9eb97730f5fde14b9be7acfd34bf6fd26c2f6"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab613d02c486f23304ae31ec10ec33299cf0dd08dd9cea58178b0398fa0c6424"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f445f24edeb7a431b44589f02840a26e578ed67ae53aabc7a011f164ede4a713"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0e4e2a61eda438a5e9fbcf8b6079a11d41f414b5334905918cf968c01898694"
    sha256 cellar: :any_skip_relocation, sonoma:         "b25bd0806cd3b3668b40284c301137853b5f0cf32e77e5a2c1aa380c30d208c7"
    sha256 cellar: :any_skip_relocation, ventura:        "c58273df4e36116e60b4f6685f46bb0d57eaf329dd52cc483c3a1eac7fd7c2ed"
    sha256 cellar: :any_skip_relocation, monterey:       "9a08af2c4eaf139f627e37bd2fbb00daecdcc7b54617c93d187cf2a527d34a2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "528dbbe8494556c56ba7ebef564b200b8ad5ff38c95675b2bdfbdf5828e2de07"
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