class Witr < Formula
  desc "Why is this running?"
  homepage "https://github.com/pranshuparmar/witr"
  url "https://ghfast.top/https://github.com/pranshuparmar/witr/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "6e0bdb4b13bb32e7f4111bc88f20b7e142b9856b411ad0905fc4b7de9e05d71c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0f912c7fd5b289db0afbc2de383ec8dcc9fe06f86520385db1331a39e57d989"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1484d7c3a36aa67447e8023eeaec85ac2695214bc4267802ca386b87ccfededa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66e3c675a28a6898b492b3acff685db2443ad6651a1f5a490fd9b490bd87f263"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c79af8f56b3388a6543d757e48dcd3cec10c494a9199789c0ff47e10286c4fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cac47211302609157c14b7c3dec6ef353178c7ddbb8575227e534b2685812e98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ff8914ac0bd6b0b62fae5d06cb6f0efe68447773b542db97fb5351355c1bb54"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.buildDate=#{time.iso8601}"), "./cmd/witr"
    generate_completions_from_executable(bin/"witr", "completion")
    man1.install "docs/cli/witr.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/witr --version")
    assert_match "Error: no process ancestry found", shell_output("#{bin}/witr --pid 99999999 2>&1", 1)
  end
end