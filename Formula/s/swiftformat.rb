class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https:github.comnicklockwoodSwiftFormat"
  url "https:github.comnicklockwoodSwiftFormatarchiverefstags0.53.1.tar.gz"
  sha256 "36c60a6e4e59efa7116b1d0575fd87685930561bfd62f0d110b26ed5297dd6ad"
  license "MIT"
  head "https:github.comnicklockwoodSwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b3ee778580222d212eae191545facae626a92ecc87fab8dc2c4ab9c73b8f7fc0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "851bcaf543795cce7186c2c290720ece7082e59e9cb9f872da31e0259d3a8d4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a594e95a5990044d0491bae31abb5f2c48f6a40e7fb2adc921de9d8ff7340a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "54129a81a0531efdc5cccd6ee25064c0a7a085421515076aa9eda2fa3f1218e1"
    sha256 cellar: :any_skip_relocation, ventura:        "f45571cb2bbe39e57eec263e1e2616113db745b30aad6cd342d468cc362e4b5b"
    sha256 cellar: :any_skip_relocation, monterey:       "67facbde7c6a180799a482ecfd8e48ddc0050a6ef2d90d72ed856149ddd3cfa0"
    sha256                               x86_64_linux:   "e6857f7ea39f05fe30698903225b0ccf9e830946f96f55ca9d08c4694ea067a6"
  end

  depends_on xcode: ["10.1", :build]

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".buildreleaseswiftformat"
  end

  test do
    (testpath"potato.swift").write <<~EOS
      struct Potato {
        let baked: Bool
      }
    EOS
    system "#{bin}swiftformat", "#{testpath}potato.swift"
  end
end