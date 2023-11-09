class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://ghproxy.com/https://github.com/cloudflare/cloudflare-go/archive/refs/tags/v0.81.0.tar.gz"
  sha256 "546d68a827537282d1f36f946f81f3681978636cc092d2c09deebeae503b4acc"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "668d65e4dc437c175900426eafc5ff4f90d1687f135b49edf2c508ffecdaa9df"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "629be100efd97129901d76af9dd94c4c7d938bef94b432a5c1b99726154c2e79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fefb5a229b47fe773355a5849e8bafccd832a798c42bbd29fd22fbfd4db8d40"
    sha256 cellar: :any_skip_relocation, sonoma:         "d951e13b5693b3abde84ff4509da9c6d9538883c0c1a25801bfcc42072d956f7"
    sha256 cellar: :any_skip_relocation, ventura:        "9302b3abb703c3e212632165597fcb08dc58cbb331128d0cdc5d7b8c6fda5244"
    sha256 cellar: :any_skip_relocation, monterey:       "85a3dd5944f5a59b3057557c97784640f871a5fae71fbcb6cb5d3e31c74dc0ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "807f06470f883a219719ec032881009a6b9e14db99889b7e1cc3ab53bc7b4795"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/flarectl"
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "Invalid request headers (6003)", shell_output("#{bin}/flarectl u i", 1)
  end
end