class WriteGood < Formula
  desc "Naive linter for English prose"
  homepage "https:github.combtfordwrite-good"
  url "https:registry.npmjs.orgwrite-good-write-good-1.0.8.tgz"
  sha256 "f54db3db8db0076fd1c05411c7f3923f055176632c51dc4046ab216e51130221"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ce08c97d8a8666ed1721ab835d166e1ff865e2ee2ab23c58018021baf89cf360"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3f919d6545b2ec2edebf3501d9eb7531687b3247f2b4fbf8a082bcca34f49405"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c0ae187140e31156c039234b5c38df8a326125edcd1ca45a3ef661c620002e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d7f61673e4bf3404da929427c3ac1003ba259f9d781248d1cfde01da6780d6c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "61d0833a983986732c1d6abb5491a3cc787f30c6987d2c420ef69af5a82e8340"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f919d6545b2ec2edebf3501d9eb7531687b3247f2b4fbf8a082bcca34f49405"
    sha256 cellar: :any_skip_relocation, ventura:        "a6794938945be53cbfe3e94f6bf16e8f260bb3ff5f40eeb2d37f64d97c48382d"
    sha256 cellar: :any_skip_relocation, monterey:       "86bd56a8ef2b340804f9da813b086f49f2f2f9f6eb8f31fe1d4137c2c44a1202"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d0239747d4aaff293b839c0cd3d4ee175eb69260d965d810b33b4081a20845c"
    sha256 cellar: :any_skip_relocation, catalina:       "1bb59d5fc6bc1e3350b3ff45eef3aa3e78500e3cd9342c690f6dcf8b6163a77b"
    sha256 cellar: :any_skip_relocation, mojave:         "0850f0679ded1af752f6f62b3f88e80134563cfd6d313c9d9b7e42549d421d9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b0159ea80386272010aec12e84b6c7793b2a358b6f1320797cca326b2c61d61"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    (testpath"test.txt").write "So the cat was stolen."
    assert_match "passive voice", shell_output("#{bin}write-good test.txt", 2)
  end
end