class MercuryCli < Formula
  desc "CLI interface for Mercury banking"
  homepage "https://github.com/MercuryTechnologies/mercury-cli"
  url "https://ghfast.top/https://github.com/MercuryTechnologies/mercury-cli/archive/refs/tags/v0.11.7.tar.gz"
  sha256 "5414f2cb79a74611dac9bbb039074604aca6869692fe6164ed3e9aa18ef3aea9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff94dcad36f64ef51571fb9cda33f99e5dcad36804d27a7a4edf93a7df9b703d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff94dcad36f64ef51571fb9cda33f99e5dcad36804d27a7a4edf93a7df9b703d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff94dcad36f64ef51571fb9cda33f99e5dcad36804d27a7a4edf93a7df9b703d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee1851d968df37d65b240b2da49efab690d3b17652c8b68601eb573ad171c7e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf796120c0a93313c33c06c79c09e62c3a3eb0290be8b775a000d9927bcbf332"
    sha256 cellar: :any,                 x86_64_linux:  "51acf7f0f7cfa84cc5f1beb8599e7c6c7217cc85dd866c4c7bb682f1a8f520e5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"mercury"), "./cmd/mercury"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mercury --version")
    assert_match "Authentication Status", shell_output("#{bin}/mercury status 2>&1")
    assert_match "Your dedication to modern banking has not gone unnoticed", pipe_output("#{bin}/mercury hat 2>&1")
  end
end