class Xcsift < Formula
  desc "Swift tool to parse xcodebuild output for coding agents"
  homepage "https://github.com/ldomaradzki/xcsift"
  url "https://ghfast.top/https://github.com/ldomaradzki/xcsift/archive/refs/tags/v1.1.5.tar.gz"
  sha256 "ce03df0eb383b9f4116fa021b8f8fe2c9acd33e272e36f2f91f29776f79b3465"
  license "MIT"
  head "https://github.com/ldomaradzki/xcsift.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a41e4d343f18e4088179f952e8f3c3aca26e78cd0ce6381dfb888481a9443aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ff63da0233e7a7c05bb75a115ac3e9211a3919f3a10fad65094b489d04ae589"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0664282280780583cae560e48a5310150ac2976b8df6adbf79e76d873ca5c50b"
    sha256 cellar: :any_skip_relocation, sonoma:        "adbe104f780760932f7a04f4f07f83bd48624217736155f1b488eb47addf7887"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3d5ab2b3e7a77d8ea7356d1e75108c4f873017f45aafb9550b00bb63ea28d2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a113e69d39555a4061e5a60c77b870b339f0303cbd6452a95702f1da2df71c5"
  end

  depends_on xcode: ["16.0", :build]
  uses_from_macos "swift" => :build, since: :sonoma

  def install
    inreplace "Sources/main.swift", "VERSION_PLACEHOLDER", version.to_s

    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end

    system "swift", "build", *args, "-c", "release"
    bin.install ".build/release/xcsift"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xcsift --version")

    output = pipe_output(bin/"xcsift", "Build succeeded")
    assert_match "status", output
    assert_match "summary", output
  end
end