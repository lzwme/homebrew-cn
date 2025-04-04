class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https:x-cmd.com"
  url "https:github.comx-cmdx-cmdarchiverefstagsv0.5.6.tar.gz"
  sha256 "7e60e2851d9eafd2474b17706fef9919a31eba5aacdfd79e8f4d488f477ca021"
  license all_of: ["AGPL-3.0-only", "MIT", "BSD-3-Clause"]

  head "https:github.comx-cmdx-cmd.git", branch: "X"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9e9d45759eb975546409d87239bc4dc4481bfcf5ede5c671a41847d4e95179b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9e9d45759eb975546409d87239bc4dc4481bfcf5ede5c671a41847d4e95179b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a9e9d45759eb975546409d87239bc4dc4481bfcf5ede5c671a41847d4e95179b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4412b5da947a0c7fdb8c2a29b931bbf6653a94d924c303532864d4649196673e"
    sha256 cellar: :any_skip_relocation, ventura:       "4412b5da947a0c7fdb8c2a29b931bbf6653a94d924c303532864d4649196673e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9e9d45759eb975546409d87239bc4dc4481bfcf5ede5c671a41847d4e95179b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9e9d45759eb975546409d87239bc4dc4481bfcf5ede5c671a41847d4e95179b"
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