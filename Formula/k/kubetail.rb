class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https:www.kubetail.com"
  url "https:github.comkubetail-orgkubetailarchiverefstagscliv0.2.1.tar.gz"
  sha256 "9f03737938461808ccb84a3f8d643db8e241a4603da165ad48f037e4f7a66136"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8f1936d00201b18d49c2f9dc92e152cd57142a25b40096e8b95d29c4ace4abe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93d194c9fc3195dcf957a442898ff001874db842caf25d57d6adb30cd946266d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a51ccd5b20f7d068507ae615cd594644f4e7ace109300a8fd52f76667eec790d"
    sha256 cellar: :any_skip_relocation, sonoma:        "94857c50d2b6f4f9ca77700e564551177d15c19ca12481a242816661280e5ce5"
    sha256 cellar: :any_skip_relocation, ventura:       "a03b2d8ca643c12d55acd2c0ed3c937a94fd01b1d8778158a9e658c57a7b889f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea955801fce6ee766d21a33ec261d7ea9dca7e489b597180cb529ad93daca443"
  end

  depends_on "go" => :build
  depends_on "make" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "binkubetail"
    generate_completions_from_executable(bin"kubetail", "completion")
  end

  test do
    command_output = shell_output("#{bin}kubetail serve --test")
    assert_match "ok", command_output

    assert_match version.to_s, shell_output("#{bin}kubetail --version")
  end
end