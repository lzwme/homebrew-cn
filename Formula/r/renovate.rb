class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.175.0.tgz"
  sha256 "cdab5f1bd32249d45058655173d75af56a18554df09d6bce5dd6b05943a60412"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https:github.comrenovatebotrenovatetags"
    regex(%r{href=["']?[^"' >]*?tagv?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b4ff81654ba5a7861f7e4361436ff3d2b5b4bebba4d8f6339426e73ba1b3c72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "595ca1cd2c8395a9f5282cbb872e82e199238a32b9747788c0bbe25de642cff9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e8d5cc3bfabe74a8179e4e8f88db09bd7eec533808b5f8b9b28b894bc4677c82"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6f86e78629a8aab648666b9985dfd51d79dab32fa86fc883cf579e73928b9ae"
    sha256 cellar: :any_skip_relocation, ventura:       "5243dc104f705785c63081a5c0bed44588049a12856e835cdf007dd91b12698d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab8ea048e877ecb4571a9dcfbf1fb152f1a4e5aa6461bced12f49a06e105a0c3"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"renovate", "--platform=local", "--enabled=false"
  end
end