class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://github.com/binwiederhier/ntfy.git",
      tag:      "v2.4.0",
      revision: "4a8ed8e65f0abb2699c517cef1b1ec0d6a4fe268"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13b9fbbed87a62d2e37b0f3c8c55ad7d9ecea40fa19ebbe097f2f112db69826c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87c7542fac3c13c4d0ba711fb5b35510b3cf7fee29c7fd6ce0213a4840ec62a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ebe8eb2b978a051b1b00ad0f40d51cb02dfbd335475e8a581b2fae344c3fe6d"
    sha256 cellar: :any_skip_relocation, ventura:        "15626e76ec2698b4cb559002b821e4a6089f8b105b016cc32d926d35faef3a2f"
    sha256 cellar: :any_skip_relocation, monterey:       "25d706fb50d231fcec1d6c20c78a23a674a56d464642f13d9c502a0ff9144837"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d82e78af78e00b0dda5348837c5ee1b9f97ecf0d43bef1a9a4632182de74364"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c36bf726748b5d31bebcca52f2677320c428f284734bca9fb675676a4b3845a"
  end

  depends_on "go" => :build

  def install
    system "make", "cli-deps-static-sites"
    ldflags = %W[
      -X main.version=#{version}
      -X main.date=#{time.strftime("%F")}
      -X main.commit=#{Utils.git_head}
      -s
      -w
    ]
    with_env(
      "CGO_ENABLED" => "0",
    ) do
      system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "noserver"
    end
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