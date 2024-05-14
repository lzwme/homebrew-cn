class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https:github.comcloudflarecloudflare-gotreemastercmdflarectl"
  url "https:github.comcloudflarecloudflare-goarchiverefstagsv0.95.0.tar.gz"
  sha256 "394fec591f9ae1fdda0f2827ae012c320c799c9ec3adb0549c699be8851f6fc0"
  license "BSD-3-Clause"
  head "https:github.comcloudflarecloudflare-go.git", branch: "master"

  livecheck do
    url :stable
    # track v0.x releases
    regex(^v?(0(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3e09b03ecf5e08e77c27633c464e9fe4024a42e7a629741f28eb8137d36da037"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4121a88ca777d21ea525bb85d0463f4950fb741e6ee86878bd3fa32d00d5280"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "178bfd9ef6132c4067c965988695cc63744ae0e24927070c650f664723c9c506"
    sha256 cellar: :any_skip_relocation, sonoma:         "416c67c8d7ae90d7af79c3e15a5eb889b00d9927262d60fb3f8f6403e5c6a25a"
    sha256 cellar: :any_skip_relocation, ventura:        "b0a74ba3119a1a99042147250bd8e21a803c62715e8b4b2845b97cffb895a0a2"
    sha256 cellar: :any_skip_relocation, monterey:       "ca1676c9dbcc4e1782250261fbc4695442a8f9da85320e45a8161aeb1176a15e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89a9d67cb5b5ae158428d134c28305192d39f15c9f8a5fb29bc1db227d7172e2"
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