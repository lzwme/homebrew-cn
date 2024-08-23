class Dolt < Formula
  desc "Git for Data"
  homepage "https:github.comdolthubdolt"
  url "https:github.comdolthubdoltarchiverefstagsv1.42.14.tar.gz"
  sha256 "411fb29cd0b0904513a42fd195ca3238ae8845cfd01013b7964856d7da4917cd"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1102bdda7c54d64b5291248c51e5cd750be067f0c25aee7b64e4e8021537285f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60617cebb1123a88134dd91e9a3ebbaf22a8c6397d16c2b369d600bbf92e6b95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f995d92263b6ec20b38a66f6b0bf1e691ac26ed6fd96ff6cd78b3cd241762b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "00b73dc4fbdab5a0b3426a464b6e6150face1ce34d11ee5d913cb4e997cc388c"
    sha256 cellar: :any_skip_relocation, ventura:        "2b3971576ca5d903a845b7407b50b0fb9ef60d37b3484f78631ffe0cc8812190"
    sha256 cellar: :any_skip_relocation, monterey:       "cabed347440012f4dd65449be5ef392cebf86a2990ad6db04188ee3d7ee36a00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07f099df0289dfdd33febb0d1163bd4c3a6f36bc34c830697f03227dd69f2747"
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