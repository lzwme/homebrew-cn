class Godap < Formula
  desc "Complete TUI (terminal user interface) for LDAP"
  homepage "https://github.com/Macmod/godap"
  url "https://ghfast.top/https://github.com/Macmod/godap/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "996dbf0f66a681de337b65caee65a55af3d52894049dd61e66eb429c96d24a4a"
  license "MIT"
  head "https://github.com/Macmod/godap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cea4155507e230bfdb11e2b9690c2683472555cf0aab191761b881c8b8b202b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cea4155507e230bfdb11e2b9690c2683472555cf0aab191761b881c8b8b202b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cea4155507e230bfdb11e2b9690c2683472555cf0aab191761b881c8b8b202b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "62b2350285037dad4576fdf976c50c0c840f2cb977825ea0c62fab6683ef1054"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a42560bc144cb0f1b8b5e45673f43f2ed329f99c7d40f2a985b74d66ac0736a5"
    sha256 cellar: :any,                 x86_64_linux:  "a023e8320f2af034185c70e5200bc0c125f4678f12e0e6ddcca28b559bd52486"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}")
    generate_completions_from_executable(bin/"godap", shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/godap -T 1 203.0.113.1 2>&1", 1)
    assert_match "determine target hostname for TLS verification: reverse lookup 203.0.113.1", output

    assert_match version.to_s, shell_output("#{bin}/godap version")
  end
end