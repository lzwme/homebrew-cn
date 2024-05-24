class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https:github.comcloudflarecloudflare-gotreemastercmdflarectl"
  url "https:github.comcloudflarecloudflare-goarchiverefstagsv0.96.0.tar.gz"
  sha256 "e95f6b9b9b457b1ae67e6d38e8eeda8203c913cdf65a78879b5bd68b4baa5b3e"
  license "BSD-3-Clause"
  head "https:github.comcloudflarecloudflare-go.git", branch: "master"

  livecheck do
    url :stable
    # track v0.x releases
    regex(^v?(0(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "79999174e1b4b3f1f1523611cc7fdeca1b0805c1e3305ec6275ae1922e2594e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91e2ddf68b343c4b789cc3197a1238d323162e724b0ca7712e2a62a8196112f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13935225799518c8926989bce0a5035d35741395a21dd6e15f45d3b5ed3d7958"
    sha256 cellar: :any_skip_relocation, sonoma:         "e01c5cbc9732481efd04627a041de7da6d7c623eec554a7545b9f0968d21bcca"
    sha256 cellar: :any_skip_relocation, ventura:        "a4d68760087bcd645c39c7f36ad59018455f626eba78412dd84c2b45cfa45dfd"
    sha256 cellar: :any_skip_relocation, monterey:       "105f057297d979b012ba8fc27456ce979f17703fbbc1244c235ecb7aac716578"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2112b13666d8f9e189affc6be6b8d6d5df85c9ea250a714226522c1c6f483c94"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdflarectl"
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "Invalid request headers (6003)", shell_output("#{bin}flarectl u i", 1)
  end
end