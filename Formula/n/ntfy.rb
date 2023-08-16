class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://github.com/binwiederhier/ntfy.git",
      tag:      "v2.6.2",
      revision: "88eb728fe396a599ff1f2d339bdd6b4e5a18fb22"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7637a8a1858601b4d2ea5bac9d0109b54743d1bc258be30b1cc03b8c7e777623"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7637a8a1858601b4d2ea5bac9d0109b54743d1bc258be30b1cc03b8c7e777623"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7637a8a1858601b4d2ea5bac9d0109b54743d1bc258be30b1cc03b8c7e777623"
    sha256 cellar: :any_skip_relocation, ventura:        "dae163181db62cd42c5ed486632cc5daab1e9446a8b9c7758c42359657e77d8d"
    sha256 cellar: :any_skip_relocation, monterey:       "dae163181db62cd42c5ed486632cc5daab1e9446a8b9c7758c42359657e77d8d"
    sha256 cellar: :any_skip_relocation, big_sur:        "dae163181db62cd42c5ed486632cc5daab1e9446a8b9c7758c42359657e77d8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c372874817d5a7142720e96bb3f9fc1679b95b8e3555122d58d3c2ccbbb9b11"
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