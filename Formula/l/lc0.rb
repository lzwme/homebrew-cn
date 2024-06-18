class Lc0 < Formula
  desc "Open source neural network based chess engine"
  homepage "https:lczero.org"
  url "https:github.comLeelaChessZerolc0.git",
      tag:      "v0.31.0",
      revision: "018f28bad2fc0a6214e73bc937ae46e8c770bf0e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a599cbd6a5e3cb80a4c85e19bcc36ae84d6bac787ff5d6b4e8c46c84de5c242f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1079a0e3b693569b0907ef68813f7850bd5fe69e46073b3670bb35644c0efd7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1889e860e75f05901ab9801ad22e664c930d29300e64a8481a702148ab98ce2"
    sha256 cellar: :any_skip_relocation, sonoma:         "43d2caabce024410302728eeba787263dd7859d99cadcbadb67ced3549c3cfc3"
    sha256 cellar: :any_skip_relocation, ventura:        "2e6e0ecc756b4fe727bbb462b61a9752340b4c23f8f3eaf99a6a86be4868ebd7"
    sha256 cellar: :any_skip_relocation, monterey:       "66edcc0e9029723c948a6c9121365deabd2cefee003302920c36ba4de99db677"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc810dd1a50558bc10e2ce6d0070089a31bccd97937915fb9032b6fc8a71f769"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "eigen"

  uses_from_macos "python" => :build # required to compile .pb files
  uses_from_macos "zlib"

  on_linux do
    depends_on "openblas"
  end

  fails_with gcc: "5" # for C++17

  # We use "753723" network with 15 blocks x 192 filters (from release notes)
  # Downloaded from https:training.lczero.orgnetworks?show_all=0
  resource "network" do
    url "https:training.lczero.orgget_network?sha=3e3444370b9fe413244fdc79671a490e19b93d3cca1669710ffeac890493d198", using: :nounzip
    sha256 "ca9a751e614cc753cb38aee247972558cf4dc9d82c5d9e13f2f1f464e350ec23"
  end

  def install
    args = ["-Dgtest=false"]

    if OS.mac?
      # Disable metal backend for older macOS
      # Ref https:github.comLeelaChessZerolc0issues1814
      args << "-Dmetal=disabled" if MacOS.version <= :big_sur
    else
      args << "-Dopenblas_include=#{Formula["openblas"].opt_include}"
      args << "-Dopenblas_libdirs=#{Formula["openblas"].opt_lib}"
    end
    system "meson", *std_meson_args, *args, "buildrelease"

    cd "buildrelease" do
      system "ninja", "-v"
      libexec.install "lc0"
    end

    bin.write_exec_script libexec"lc0"
    resource("network").stage { libexec.install Dir["*"].first => "42850.pb.gz" }
  end

  test do
    assert_match "Creating backend [blas]",
      shell_output("#{bin}lc0 benchmark --backend=blas --nodes=1 --num-positions=1 2>&1")
    assert_match "Creating backend [eigen]",
      shell_output("#{bin}lc0 benchmark --backend=eigen --nodes=1 --num-positions=1 2>&1")
  end
end