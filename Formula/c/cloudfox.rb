class Cloudfox < Formula
  desc "Automating situational awareness for cloud penetration tests"
  homepage "https:github.comBishopFoxcloudfox"
  url "https:github.comBishopFoxcloudfoxarchiverefstagsv1.13.1.tar.gz"
  sha256 "5877c7293ea4220b385636927a3edc526b40048661f82c480c954c93623553fa"
  license "MIT"
  head "https:github.comBishopFoxcloudfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c39be627bb0e20fe63e12d73643d49c4e57dc159f60e97b4072e31dd4d8df74b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b2175c262201b217720636f97cd018db971fd7c89076f4b2d50a058c0781575"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f891ad78be886bcbcc30cd338c6d39800152b5be1aef1b85e8a175f529c972ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "3063c4e8535ad76c4d63f680cba490b969db55ec9b689a7d901f5159768a803a"
    sha256 cellar: :any_skip_relocation, ventura:        "da777b1f724be59b5a8b4d344329a120fbfed6004cd973da92b74eb6934bc73a"
    sha256 cellar: :any_skip_relocation, monterey:       "9f3e95da3b3df99a0a03b793831b527b27bc37e9240f58f4404526db4be81cfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df092839da83594414a6c2c0251796d9b31c4e6d067fe1a773a840eb8571fb3e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin"cloudfox", "completion")
  end

  test do
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"

    output = shell_output("#{bin}cloudfox aws principals 2>&1")
    assert_match "Could not get caller's identity", output

    assert_match version.to_s, shell_output("#{bin}cloudfox --version")
  end
end