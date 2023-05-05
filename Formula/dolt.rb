class Dolt < Formula
  desc "Git for Data"
  homepage "https://github.com/dolthub/dolt"
  url "https://ghproxy.com/https://github.com/dolthub/dolt/archive/v0.75.19.tar.gz"
  sha256 "d714c769e13801a677c39f8a037f59f9276fa7676eccb7f06227c3fa8669c6f2"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8a903852bf03427d966c773677017c8866b006b820224ca8650094e0328ba1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8a903852bf03427d966c773677017c8866b006b820224ca8650094e0328ba1b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e8a903852bf03427d966c773677017c8866b006b820224ca8650094e0328ba1b"
    sha256 cellar: :any_skip_relocation, ventura:        "287c323abb2a170ef5ce655f648d2823dcac95b318fad7ef1816c00326674139"
    sha256 cellar: :any_skip_relocation, monterey:       "287c323abb2a170ef5ce655f648d2823dcac95b318fad7ef1816c00326674139"
    sha256 cellar: :any_skip_relocation, big_sur:        "287c323abb2a170ef5ce655f648d2823dcac95b318fad7ef1816c00326674139"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f11de580eb2acba996c77c46535f542f28188eee2747e0b591c1af29fd4ba5e"
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