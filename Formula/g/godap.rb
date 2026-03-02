class Godap < Formula
  desc "Complete TUI (terminal user interface) for LDAP"
  homepage "https://github.com/Macmod/godap"
  url "https://ghfast.top/https://github.com/Macmod/godap/archive/refs/tags/v2.10.8.tar.gz"
  sha256 "443cdd98012243ae25f54ffb9947aa2d5479d17b2a2b95e7b97aca07785590ea"
  license "MIT"
  head "https://github.com/Macmod/godap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4deb739807d6561f011256ee06151a42d0065cbd09d6ce2d6b1be3ba59d41539"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4deb739807d6561f011256ee06151a42d0065cbd09d6ce2d6b1be3ba59d41539"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4deb739807d6561f011256ee06151a42d0065cbd09d6ce2d6b1be3ba59d41539"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe1781a854f4d1074d73acb4ebe3cade9815b9e8fec83fe31a6746ecf2860d79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "824769465170d0c6c6fa2fb03a73cc84ca020e41fed3572661106fab0333b7bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d15d1f4e8d5e9ad5dd02f873ba4aec0e16cf58c670ff8caf23b2ee73e5edd0d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")
    generate_completions_from_executable(bin/"godap",  shell_parameter_format: :cobra)
  end

  test do
    output = shell_output("#{bin}/godap -T 1 203.0.113.1 2>&1", 1)
    assert_match "LDAP Result Code 200 \"Network Error\": dial tcp 203.0.113.1:389: i/o timeout", output

    assert_match version.to_s, shell_output("#{bin}/godap version")
  end
end