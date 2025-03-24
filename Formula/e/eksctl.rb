class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https:eksctl.io"
  url "https:github.comeksctl-ioeksctl.git",
      tag:      "0.206.0",
      revision: "238b7355608373c27700de5bb0d2d57238ab37c0"
  license "Apache-2.0"
  head "https:github.comeksctl-ioeksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e87e31b7281091045bdf84078217fbfd380d86918de19d21f1399f1d65f6d86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d891dd420949dddd087e96e3a023d0cf1a0b80c41eddee63bfba32ee21bdd935"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "73b041f01a6c84a56dd18ff6e682e375dee319c9d089cd3058f536d9e22c708e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3596d395c1f6710cd80e03553015c115e7ecfc284401882950bbaa05cddb012"
    sha256 cellar: :any_skip_relocation, ventura:       "d708f321fa2704c741714011f807087b5c99093c12dfe10a515649adcbc0ac29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5764d7b515b8c13e7ddbd80806acc686434031fc0b54efb428ba76add6fbb87"
  end

  depends_on "go" => :build

  def install
    system "make", "binary"
    bin.install "eksctl"

    generate_completions_from_executable(bin"eksctl", "completion")
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}eksctl create nodegroup 2>&1", 1)
  end
end