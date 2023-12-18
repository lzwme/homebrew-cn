class Dalfox < Formula
  desc "XSS scanner and utility focused on automation"
  homepage "https:dalfox.hahwul.com"
  url "https:github.comhahwuldalfoxarchiverefstagsv2.9.1.tar.gz"
  sha256 "aaeac4663757b1c0a1477d78cc6c793023ac01c154ec79f6a1746db7d0cf1b2d"
  license "MIT"
  head "https:github.comhahwuldalfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c00b154919eedecb66cd8e825aec5a5d80b08a97ab10e800328b7b36999ed59"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c4a62308a140d0d0c25a0de064b7cd2c881940e1b6df1e6447bdaa569b6d551"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5dd3d0940c19c2e1c744251750a67cf6d036f635676ef9be2c6755fdcbc07b84"
    sha256 cellar: :any_skip_relocation, sonoma:         "2753e8ac5e4350e6f93e7c5ef132ed8df5e5487584ccda66f09743ec32957e30"
    sha256 cellar: :any_skip_relocation, ventura:        "1fac56d9d53b91fa7fe786ba9f655049279737d503827bf02b99f2473e18608d"
    sha256 cellar: :any_skip_relocation, monterey:       "2ed82f380fb0f891a26ef95516ff50304f87e066c43e29e0a8243f05616b3805"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f4a66a9c8ca02f7cb2e46231a5b7fc05f3b6cc7c398217bc548bb3bcac4e0a1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin"dalfox", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}dalfox version 2>&1")

    url = "http:testphp.vulnweb.comlistproducts.php?cat=123&artist=123&asdf=ff"
    output = shell_output("#{bin}dalfox url #{url}")
    assert_match "[POC][G][GET][BUILTIN]", output
  end
end