import { useNavigate } from "react-router-dom";
import { signOut } from "supertokens-auth-react/recipe/session";
import CallAPIView from "./CallAPIView";
import {CelebrateIcon, SeparatorLine, SignOutIcon } from "../assets/images";
import { getApiDomain } from "../config";
import axios from "axios";


interface ILink {
    name: string;
    onClick: () => void;
    icon: string;
}

export default function SuccessView(props: { userId: string }) {
    let userId = props.userId;

    const navigate = useNavigate();

    async function logoutClicked() {
        await signOut();
        navigate("/auth");
    }

    async function deleteUserClicked() {
        let response = await axios.get(getApiDomain() + "/deleteUser");
        await signOut();
        navigate("/auth");
    }


    function openLink(url: string) {
        window.open(url, "_blank");
    }

    const links: ILink[] = [
        {
            name: "Sign Out",
            onClick: logoutClicked,
            icon: SignOutIcon,
        },
        {
            name: "Delete user",
            onClick: deleteUserClicked,
            icon: SignOutIcon,
        },
    ];

    return (
        <>
            <div className="main-container">
                <div className="top-band success-title bold-500">
                    <img src={CelebrateIcon} alt="Login successful" className="success-icon" /> Login successful
                </div>
                <div className="inner-content">
                    <div>Your userID is:</div>
                    <div className="truncate" id="user-id">
                        {userId}
                    </div>
                    <CallAPIView />
                </div>
            </div>
            <div className="bottom-links-container">
                {links.map((link) => (
                    <div className="link" key={link.name}>
                        <img className="link-icon" src={link.icon} alt={link.name} />
                        <div role={"button"} onClick={link.onClick}>
                            {link.name}
                        </div>
                    </div>
                ))}
            </div>
            <img className="separator-line" src={SeparatorLine} alt="separator" />
        </>
    );
}
