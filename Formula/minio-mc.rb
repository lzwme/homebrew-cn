class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      tag:      "RELEASE.2023-04-06T16-51-10Z",
      revision: "1c6f4f48aba72b4c9770d911e95225f9de6e9488"
  version "20230406165110"
  license "AGPL-3.0-or-later"
  head "https://github.com/minio/mc.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/(?:RELEASE[._-]?)?([\dTZ-]+)["' >]}i)
    strategy :github_latest do |page, regex|
      page.scan(regex).map { |match| match&.first&.gsub(/\D/, "") }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f88fd1e9ff27cfb8c7e288cc2fb5a217b879e02397cd9c08072c0164aaa8ab7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e08b60c97e85269347c93ed343cd50b392db9b3548b0a17869d0adb7aa8a1a35"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f73320145e3f7a79ebcf25d3a2ec6636f94bf0c59970f735995f30f7944da9a0"
    sha256 cellar: :any_skip_relocation, ventura:        "401d9a04c10a4fdb472e34bd349a7794dd5bc09832fb859224f2304bec032806"
    sha256 cellar: :any_skip_relocation, monterey:       "2db590181a38b676a41b347dcf2f27a2575c862f619c1d1ce295a3bb91772364"
    sha256 cellar: :any_skip_relocation, big_sur:        "52be58597b88a02eb2e5b422cf89fe978bc3be5049e083d3b449d11954044f48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae6009393797f110aa1de871d74b1df9638766dddb9d870ad866fe7a211686ad"
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", because: "both install an `mc` binary"

  def install
    if build.head?
      system "go", "build", *std_go_args(output: bin/"mc")
    else
      minio_release = stable.specs[:tag]
      minio_version = minio_release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)-(\d+)-(\d+)Z/, 'T\1:\2:\3Z')
      proj = "github.com/minio/mc"
      ldflags = %W[
        -X #{proj}/cmd.Version=#{minio_version}
        -X #{proj}/cmd.ReleaseTag=#{minio_release}
        -X #{proj}/cmd.CommitID=#{Utils.git_head}
      ]
      system "go", "build", *std_go_args(output: bin/"mc", ldflags: ldflags)
    end
  end

  test do
    system bin/"mc", "mb", testpath/"test"
    assert_predicate testpath/"test", :exist?
  end
end