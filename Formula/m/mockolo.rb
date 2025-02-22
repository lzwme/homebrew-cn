class Mockolo < Formula
  desc "Efficient Mock Generator for Swift"
  homepage "https:github.comubermockolo"
  url "https:github.comubermockoloarchiverefstags2.2.0.tar.gz"
  sha256 "6778f861c72efc8e3d67c10f4f825b4e4b746a05829301e0cb9645150534eadf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7b395c4bc5f3d56bd72339c4560016be2922280c853298ebd533f885cb3caeb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ccc7031e39a88e3dce3bb4ed2fa56edc51e7353768ed9edcef211100ceba25f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e52e04d714c1ff9e26eaf94a08bcb8a8d41213a7e87081617d0dda6cd4d8cdb0"
    sha256 cellar: :any_skip_relocation, sonoma:        "82e1f3c1bc942234c41ef556f2138857a673331fd47fe29c4b56db6104746cb9"
    sha256 cellar: :any_skip_relocation, ventura:       "8b52cffebd4c5ab87bc965f7e798c39c9c2f880c8845e2ab857b6039c2ff07ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "041dce518ce1939525321057a15d1212e3ce73fc1aea237f3adbb93d9d05f122"
  end

  depends_on xcode: ["14.0", :build]

  uses_from_macos "swift" => :build

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "-c", "release", "--product", "mockolo"
    bin.install ".buildreleasemockolo"
  end

  test do
    (testpath"testfile.swift").write <<~SWIFT
       @mockable
      public protocol Foo {
          var num: Int { get set }
          func bar(arg: Float) -> String
      }
    SWIFT
    system bin"mockolo", "-srcs", testpath"testfile.swift", "-d", testpath"GeneratedMocks.swift"
    assert_path_exists testpath"GeneratedMocks.swift"
    output = <<~SWIFT.gsub(\s+, "").strip
      
       @Generated by Mockolo
      
      public class FooMock: Foo {
        public init() { }
        public init(num: Int = 0) {
            self.num = num
        }

        public private(set) var numSetCallCount = 0
        public var num: Int = 0 { didSet { numSetCallCount += 1 } }

        public private(set) var barCallCount = 0
        public var barHandler: ((Float) -> String)?
        public func bar(arg: Float) -> String {
            barCallCount += 1
            if let barHandler = barHandler {
                return barHandler(arg)
            }
            return ""
        }
      }
    SWIFT
    assert_equal output, shell_output("cat #{testpath"GeneratedMocks.swift"}").gsub(\s+, "").strip
  end
end