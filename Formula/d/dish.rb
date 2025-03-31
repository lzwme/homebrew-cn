class Dish < Formula
  desc "Lightweight monitoring service that efficiently checks socket connections"
  homepage "https:github.comthevxndish"
  url "https:github.comthevxndisharchiverefstagsv1.10.1.tar.gz"
  sha256 "ad131f52a9b3fedce05c009a27fff96d8ca5829fed000f4ed98538222b9c6fb4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c752abb80ed1d8a1570a40b063f564291cc4f58b0fd55bbae52d24aa84f3dfbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c752abb80ed1d8a1570a40b063f564291cc4f58b0fd55bbae52d24aa84f3dfbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c752abb80ed1d8a1570a40b063f564291cc4f58b0fd55bbae52d24aa84f3dfbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "bcb6b02f1a24980c85ee9d6ba5c745935d5e1077f7b9e9b99fd89d8cc3f31754"
    sha256 cellar: :any_skip_relocation, ventura:       "bcb6b02f1a24980c85ee9d6ba5c745935d5e1077f7b9e9b99fd89d8cc3f31754"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd0d855ad488c186ffdbb6b0ebda595409a2b9782d81a969c6da258663e1a798"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmddish"
  end

  test do
    ouput = shell_output("#{bin}dish https:example.com:instance 2>&1", 1)
    assert_match "error fetching sockets from remote source --- got 404 (404 Not Found)", ouput
  end
end