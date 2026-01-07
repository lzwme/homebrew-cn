class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://ghfast.top/https://github.com/gohugoio/hugo/archive/refs/tags/v0.154.3.tar.gz"
  sha256 "fac9968089db63cb44d6d7c60d0e328aa8c52d2b0349773c13008da2c8f46c76"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "654a8f02e3a233eeaeb8c6fde2b6a63bfef186d9496e335edcfb3b4e8e966a23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d0d56397fac0a790b2d61f45b453c2f4236d2661ea20f7dd4c8f468a844943f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dea629b797bbd010b1b365a8151634d1ecbd8ecfc2ed31d663e9cf259eaf8ba1"
    sha256 cellar: :any_skip_relocation, sonoma:        "a817fcab98a5b29c1f47cb44446ea858794427e1d6e9f885a1ff4133f9860d08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8768aa8a8374e2fef2b39fd971f178a8313dd131954bbefa1b660d9a4ff76605"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "671e2d5c7c443c3e46507fa60abd0517b0070b99fb2edc345f54e4c022d35791"
  end

  depends_on "go" => :build

  def install
    # Needs CGO (which is disabled by default on Linux Arm)
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/gohugoio/hugo/common/hugo.commitHash=#{tap.user}
      -X github.com/gohugoio/hugo/common/hugo.buildDate=#{time.iso8601}
      -X github.com/gohugoio/hugo/common/hugo.vendorInfo=#{tap.user}
    ]
    tags = %w[extended withdeploy]
    system "go", "build", *std_go_args(ldflags:, tags:)

    generate_completions_from_executable(bin/"hugo", shell_parameter_format: :cobra)
    system bin/"hugo", "gen", "man", "--dir", man1
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system bin/"hugo", "new", "site", site
    assert_path_exists site/"hugo.toml"

    assert_match version.to_s, shell_output("#{bin}/hugo version")
  end
end