class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://ghfast.top/https://github.com/binwiederhier/ntfy/archive/refs/tags/v2.19.1.tar.gz"
  sha256 "580aca7e71bafb7419fd7539071cedb2472724ef5731c9ca2ce4a04c959df1c2"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59095806993033f1206eb88eea8413e5eafbb08454d696bb256f39f487222d47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59095806993033f1206eb88eea8413e5eafbb08454d696bb256f39f487222d47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59095806993033f1206eb88eea8413e5eafbb08454d696bb256f39f487222d47"
    sha256 cellar: :any_skip_relocation, sonoma:        "58fa7ecc6ea0e92cd77cb95859114c86e577d9efbb15c4c398013a7d58009e1f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6350ee489a95cd2b9509de80955f2be9525921534c125b32351083a01633917"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e343e7079fee21c093ac53b64f5207ec375e20d7319c204c6251d5b9f6d7fa6"
  end

  depends_on "go" => :build

  def install
    tags = %w[noserver]
    if OS.linux?
      tags = %w[sqlite_omit_load_extension osusergo netgo]
      ENV["CGO_ENABLED"] = "1"
      # Workaround to avoid patchelf corruption when cgo is required
      if Hardware::CPU.arm64?
        ENV["GO_EXTLINK_ENABLED"] = "1"
        ENV.append "GOFLAGS", "-buildmode=pie"
      end
    end

    system "make", "cli-deps-static-sites"
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:, tags:)
  end

  test do
    require "securerandom"
    random_topic = SecureRandom.hex(6)

    ntfy_in = shell_output("#{bin}/ntfy publish #{random_topic} 'Test message from HomeBrew during build'")
    ohai ntfy_in
    sleep 5
    ntfy_out = shell_output("#{bin}/ntfy subscribe --poll #{random_topic}")
    ohai ntfy_out
    assert_match ntfy_in, ntfy_out
  end
end