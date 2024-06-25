class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https:github.comprojectdiscoveryhttpx"
  url "https:github.comprojectdiscoveryhttpxarchiverefstagsv1.6.5.tar.gz"
  sha256 "5329d93921f24a9126122f2003d6bfdee57c2cfeb16903dd40a9564c674354b6"
  license "MIT"
  head "https:github.comprojectdiscoveryhttpx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8fdb16d5f9411d4781b503d87f865bbb74fdef9f22fde33638056977755a3d77"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7d4f59b7503622519627d85c517a5569e6f56ca3cdf237a471795116369d57c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f3ff7e748e30dfbc05c9492ea6d9648dcd78a432d71dc61c54ef6a9f16baab5"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd0c7fbfbd82712e636fa9321c79830fe6ef616eee4814b9db5fd6a746478a9f"
    sha256 cellar: :any_skip_relocation, ventura:        "49c2e4791a5f43269159a9b64411e5480c1a58fdb40da74d9e6efb1ba4034aff"
    sha256 cellar: :any_skip_relocation, monterey:       "0e352ffd470bbeca54d2eb08aae3428bc79d28033eb41a48fb2f46c08e867e02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2122af052c7901cf28494fd9810f2a35c0477b50e9c20550646273a594d13eb5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdhttpx"
  end

  test do
    output = JSON.parse(shell_output("#{bin}httpx -silent -title -json -u example.org"))
    assert_equal 200, output["status_code"]
    assert_equal "Example Domain", output["title"]
  end
end