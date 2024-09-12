class Pixie < Formula
  desc "Observability tool for Kubernetes applications"
  homepage "https:px.dev"
  url "https:github.compixie-iopixie.git",
      tag:      "releasecliv0.8.3",
      revision: "a68986a7b279e369d6b1103b4558b5298ce461d0"
  license "Apache-2.0"
  head "https:github.compixie-iopixie.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^releasecliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd94e56a22fa17b865699270a47b2b9065f4c822a9161ae7ff3c7fdcae5082bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e7d7d5353bef50e7a967c25d565e018fe4940f5d80b60f2e52572663818e684"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99a417c244525ad5d1317c38f1b439d96eb18ecc71f02cbb643352e16d7dbbb6"
    sha256 cellar: :any_skip_relocation, sonoma:         "9eb7213d113e4fc3b02ac5fbbe63ed19ffa5b25cc5c2e7aa5455fa07ece02ba2"
    sha256 cellar: :any_skip_relocation, ventura:        "895200bc071528e5a9ecaaf4dbf075e3b5129d3c865fe45e13e11d455f5b9ccb"
    sha256 cellar: :any_skip_relocation, monterey:       "e064f20416072902e3585319a37d7c9d092a1dfbefc1f10b996694b98f8d1aec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2ecb9a98e1f85afa1aeb83ab47d5c32caab8ec23b87c721abe7ce9f2e872e8e"
  end

  depends_on "go" => :build

  conflicts_with "px", because: "both install `px` binaries"

  def install
    semver = build.head? ? "0.0.0-dev" : version
    ldflags = %W[
      -s -w
      -X px.devpixiesrcsharedgoversion.buildSCMRevision=#{Utils.git_short_head}
      -X px.devpixiesrcsharedgoversion.buildSCMStatus=Distribution
      -X px.devpixiesrcsharedgoversion.buildSemver=#{semver}
      -X px.devpixiesrcsharedgoversion.buildTimeStamp=#{time.to_i}
      -X px.devpixiesrcsharedgoversion.buildNumber=#{revision + bottle&.rebuild.to_i + 1}
      -X px.devpixiesrcsharedgoversion.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin"px"), ".srcpixie_cli"

    generate_completions_from_executable(bin"px", "completion", base_name: "px")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}px version")
    assert_match tap.user.to_s, shell_output("#{bin}px version")
    assert_match "You must be logged in to perform this operation.", shell_output("#{bin}px deploy 2>&1", 1)
  end
end