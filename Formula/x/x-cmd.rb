class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https:x-cmd.com"
  url "https:github.comx-cmdx-cmdarchiverefstagsv0.5.12.tar.gz"
  sha256 "40f75142d4e10c1940f5a12e49414ad18034967898f2b7a5a702c0cc8271059e"
  license all_of: ["AGPL-3.0-only", "MIT", "BSD-3-Clause"]

  head "https:github.comx-cmdx-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "998260e6eea2233ac15dd074200bf2b2d350df177218c0bad2cc2dd3ea4b0252"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "998260e6eea2233ac15dd074200bf2b2d350df177218c0bad2cc2dd3ea4b0252"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "998260e6eea2233ac15dd074200bf2b2d350df177218c0bad2cc2dd3ea4b0252"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2b1cbd517f36d7293ead308103d8a1cb294430537a77cd7d2dd56836653cff3"
    sha256 cellar: :any_skip_relocation, ventura:       "a2b1cbd517f36d7293ead308103d8a1cb294430537a77cd7d2dd56836653cff3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6cd68927d08517ab51d65cb94c81b0df08f966a21f5d925291df551ccfca6a33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cd68927d08517ab51d65cb94c81b0df08f966a21f5d925291df551ccfca6a33"
  end

  def install
    prefix.install Dir.glob("*")
    prefix.install Dir.glob(".x-cmd")
    inreplace prefix"modx-cmdlibbinx-cmd", "opthomebrewCellarx-cmdlatest", prefix.to_s
    bin.install prefix"modx-cmdlibbinx-cmd"
  end

  test do
    assert_match "Welcome to x-cmd", shell_output("#{bin}x-cmd 2>&1")
    assert_match "hello", shell_output("#{bin}x-cmd cowsay hello")
  end
end