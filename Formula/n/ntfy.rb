class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://ghfast.top/https://github.com/binwiederhier/ntfy/archive/refs/tags/v2.23.0.tar.gz"
  sha256 "6d85e20cd6edda923b23e5fbbb6f59073987c34b1aa6550d73ad9ceef277c7f6"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7756818d4f219bb908cea7761fa41ae048afa139292c22fbb785dc8f67c46038"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7756818d4f219bb908cea7761fa41ae048afa139292c22fbb785dc8f67c46038"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7756818d4f219bb908cea7761fa41ae048afa139292c22fbb785dc8f67c46038"
    sha256 cellar: :any_skip_relocation, sonoma:        "02ab27c80617e2d449cd35c6714689313ef68894ac1e85bbe6ba99f70b8eee4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b93fec7668ed7acf824edac52c6f5bc7575295151ee66efdc4550c9ef910b32e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "361fe4a59a6b9b07e78af5daca642b1032b9210cb2fc2c1299847afaddad4336"
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